# Homebrew formula for wisp-agents. Lives in the M0xoo/homebrew-tap repo as Formula/wisp-agents.rb:
#
#   brew tap m0xoo/tap
#   brew install wisp-agents
#
# The release workflow (.github/workflows/release.yml) copies this file to the tap with `url` and
# `sha256` set to the new npm tarball, so edit it here, not in the tap.
class WispAgents < Formula
  desc "Launch coding agents, skip the transcript, read the presentation"
  homepage "https://trywisp.dev/"
  url "https://registry.npmjs.org/wisp-agents/-/wisp-agents-0.40.0.tgz"
  sha256 "ffa943fb7612933731a5e4766ca04644eddcd0477b672031d43c99d95b87066f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Drop the optional Electron desktop shell. npm ignores --omit=optional on global installs, and
    # Electron fetches its ~300 MB binary into the keg on first `require`. Without it, `wisp` serves
    # the browser UI.
    electron = libexec/"lib/node_modules/wisp-agents/node_modules/electron"
    rm_r electron if electron.exist?
  end

  def caveats
    <<~EOS
      The desktop app is not included with the Homebrew install; `wisp` opens in your
      browser at http://localhost:4477.
      For the desktop app, download it from https://trywisp.dev/#download
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wisp --version")
  end
end
