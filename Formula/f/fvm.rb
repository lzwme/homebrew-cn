class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://ghfast.top/https://github.com/leoafarias/fvm/archive/refs/tags/4.1.2.tar.gz"
  sha256 "f3e77eb78459ae6917a2ac4d734360002e06072ea744d4e115afe1dc2cee1872"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16b639e9d6fac9b4e8082237f08c6bf0aeb90a8a8a17c5a0fa4c85d646860796"
    sha256 cellar: :any,                 arm64_sequoia: "ffa6a2936a3821eed814a1cec7551607572e77abd2c4d44c308777fbed03869a"
    sha256 cellar: :any,                 arm64_sonoma:  "c651efbfcd562fc328e24d8f86378e60dd41650593c0b55ceb3d47b77231a947"
    sha256 cellar: :any,                 sonoma:        "bf0cafb2cd42b290782d772253c26c5f2078163108c0133e3007b9b83d6bcda3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0eaf427e6f9c21778936c7a1ad266b2e79f0c53c9c3f4b7ebbe47ba1bda3fb49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60da9ec0fc3d1ad4653264a46a495100f420ebadd91b0e2860e5a38d1631187"
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
      exec "#{formula_opt_bin("dartaotruntime")}/dartaotruntime" "#{libexec}/fvm.aot" "$@"
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