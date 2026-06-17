class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://ghfast.top/https://github.com/leoafarias/fvm/archive/refs/tags/4.1.1.tar.gz"
  sha256 "59a76d6d6da2fb174e063de2cafb424984b26b481f6106a0cece416bcbca3f04"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7a276aac9e7b7283fa4e733b678fc5e3948a39cb6ccb95294f77bd554b79af4e"
    sha256 cellar: :any,                 arm64_sequoia: "17f448c6652b96233e15b91cdbdd38b428480306d084e2773f10f41c7cb460f8"
    sha256 cellar: :any,                 arm64_sonoma:  "caf01921615195ebcfd339437f274393b8c0cace4e93704fce6e36e10bdf98fe"
    sha256 cellar: :any,                 sonoma:        "528ef42c34a597c03a5deb2e1b02d11dcf4c556efaca53d99bed9ac6b1734ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08fe9f2975f2d9e4e9bbf62a8ac8bada79fc1178978043367cfa2cefe0ba0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df4739a9b179d6e9e416b23212b810e1ff2f8bebfe278adaf5356415209f964"
  end

  depends_on "dart-sdk" => :build
  depends_on "dartaotruntime"

  def install
    ENV["PUB_ENVIRONMENT"] = "homebrew:fvm"
    ENV["DART_SUPPRESS_ANALYTICS"] = "true"

    system "dart", "pub", "get"
    system "dart", "compile", "aot-snapshot", "--output", "fvm.aot", "bin/main.dart"
    libexec.install "fvm.aot"

    (bin/"fvm").write <<~BASH
      #!/bin/bash
      exec "#{Formula["dartaotruntime"].opt_bin}/dartaotruntime" "#{libexec}/fvm.aot" "$@"
    BASH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fvm --version")

    output = shell_output("#{bin}/fvm api context --compress")
    context = JSON.parse(output).fetch("context")
    assert_equal version.to_s, context.fetch("fvmVersion")
    assert_equal testpath.to_s, context.fetch("workingDirectory")

    assert_match "No SDKs have been installed yet.", shell_output("#{bin}/fvm list")
  end
end