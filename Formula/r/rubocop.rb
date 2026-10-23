class Rubocop < Formula
  desc "Ruby static code analyzer and formatter, based on the community Ruby style guide"
  homepage "https://docs.rubocop.org"
  url "https://ghfast.top/https://github.com/rubocop/rubocop/archive/refs/tags/v1.92.1.tar.gz"
  sha256 "8703078346c97f6da93e5b53bb6de49dba29af03f151b1495f9659ba2892909f"
  license "MIT"
  head "https://github.com/rubocop/rubocop.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4e515ccd962c3d360138eabbad262e5a6aeb4e65fdeed3b65462204f83f2d239"
    sha256 cellar: :any, arm64_tahoe:       "3daa0a072c3e5a7bd28c9d11f1d05a7f9a27df4deac6e91c5233e2b04e11ea0a"
    sha256 cellar: :any, arm64_sequoia:     "c9a986ec321dce02e8e9bff7d4a83a97fba459038b17c327f9b7687488ba9747"
    sha256 cellar: :any, arm64_linux:       "fc3720d530a57a67fbaedca6fb776dc602bae99aa15c8e2cdf260d78150fef80"
    sha256 cellar: :any, x86_64_linux:      "7400c0fefd6150b6ac6501f8b687a3a4b2a2d755d233a0de50d62944f3775b67"
  end

  depends_on "ruby"

  # List with `gem install --explain rubocop -v #{version}`
  resource "ast" do
    url "https://rubygems.org/downloads/ast-2.4.3.gem"
    sha256 "954615157c1d6a382bc27d690d973195e79db7f55e9765ac7c481c60bdb4d383"
  end

  resource "json" do
    url "https://rubygems.org/downloads/json-2.18.0.gem"
    sha256 "b10506aee4183f5cf49e0efc48073d7b75843ce3782c68dbeb763351c08fd505"
  end

  resource "language_server-protocol" do
    url "https://rubygems.org/downloads/language_server-protocol-3.17.0.6.gem"
    sha256 "5ef2c0c138f8267e1bc631d3328347d354f96724b0af22f2c79516120443b7f0"
  end

  resource "lint_roller" do
    url "https://rubygems.org/downloads/lint_roller-1.1.0.gem"
    sha256 "2c0c845b632a7d172cb849cc90c1bce937a28c5c8ccccb50dfd46a485003cc87"
  end

  resource "parallel" do
    url "https://rubygems.org/downloads/parallel-2.3.0.gem"
    sha256 "f75a3e904101ce6a1ccb6b8dc800cbafd42166d83330192438dcf29395167a6f"
  end

  resource "parser" do
    url "https://rubygems.org/downloads/parser-3.3.12.0.gem"
    sha256 "21a6d7f755d5a24dfbdc6e6b772e4e879a52e7631a88bc5a3a134606052c9828"
  end

  resource "prism" do
    url "https://rubygems.org/downloads/prism-1.8.1.gem"
    sha256 "b260c1844ee0c7ead9c938f7fd63b95888c87cc054dfb64043204eccff8116ac"
  end

  resource "racc" do
    url "https://rubygems.org/downloads/racc-1.8.1.gem"
    sha256 "4a7f6929691dbec8b5209a0b373bc2614882b55fc5d2e447a21aaa691303d62f"
  end

  resource "rainbow" do
    url "https://rubygems.org/downloads/rainbow-3.1.1.gem"
    sha256 "039491aa3a89f42efa1d6dec2fc4e62ede96eb6acd95e52f1ad581182b79bc6a"
  end

  resource "regexp_parser" do
    url "https://rubygems.org/downloads/regexp_parser-2.13.1.gem"
    sha256 "5aedb6b7c35688f51e86eef17a15374dfd287c83f4ca644b2c5f3ec50a33b44b"
  end

  resource "rubocop-ast" do
    url "https://rubygems.org/downloads/rubocop-ast-1.50.0.gem"
    sha256 "b9ca88300da0803ee222ad20cdb30494c0a784eed06fdc35d254b06d662788db"
  end

  resource "ruby-progressbar" do
    url "https://rubygems.org/downloads/ruby-progressbar-1.13.0.gem"
    sha256 "80fc9c47a9b640d6834e0dc7b3c94c9df37f08cb072b7761e4a71e22cff29b33"
  end

  resource "unicode-display_width" do
    url "https://rubygems.org/downloads/unicode-display_width-3.2.0.gem"
    sha256 "0cdd96b5681a5949cdbc2c55e7b420facae74c4aaf9a9815eee1087cb1853c42"
  end

  resource "unicode-emoji" do
    url "https://rubygems.org/downloads/unicode-emoji-4.2.0.gem"
    sha256 "519e69150f75652e40bf736106cfbc8f0f73aa3fb6a65afe62fefa7f80b0f80f"
  end

  deny_network_access!

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document"
    end
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "--no-document", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV.fetch("GEM_HOME"))
  end

  test do
    (testpath/"test.rb").write("answer=42\n")
    output = shell_output("#{bin}/rubocop --only Layout/SpaceAroundOperators test.rb", 1)
    assert_match "Layout/SpaceAroundOperators", output
  end
end