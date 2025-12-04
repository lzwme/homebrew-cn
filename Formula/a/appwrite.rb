class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-12.0.1.tgz"
  sha256 "6219e1bef799c67518d2871fbeeeda978349d75b9094b2928c28e7727605a2f8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8847b1978d3abab44203533deb860639e261536193b88d41b518a88b403866a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03f8c6ab339bd087f9a5b1f81eaea505e7033f906a69af8a49b9b233d67f84e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03f8c6ab339bd087f9a5b1f81eaea505e7033f906a69af8a49b9b233d67f84e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4412406673e641bb53943452ad2e1751c8426528388cba319e15f29fba6335e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b079320906ce2b534317e9ef820b53d3b858aaf14792323a464a6a91f4f26be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b079320906ce2b534317e9ef820b53d3b858aaf14792323a464a6a91f4f26be7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Ensure uniform bottles
    file = libexec/"lib/node_modules/appwrite-cli/lib/commands/update.js"
    homebrew_check_str = "scriptPath.includes('/opt/homebrew/') || scriptPath.includes('/usr/local/Cellar/')"
    inreplace file do |s|
      s.gsub! "scriptPath.includes('/usr/local/lib/node_modules/')", "scriptPath.includes('/lib/node_modules/')"
      s.gsub! "scriptPath.includes('/opt/homebrew/lib/node_modules/') ||", ""
      s.gsub! homebrew_check_str, "true"
    end
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end