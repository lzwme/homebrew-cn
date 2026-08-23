class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://ghfast.top/https://github.com/leoafarias/fvm/archive/refs/tags/4.1.5.tar.gz"
  sha256 "22b259d6e979e26fdcc0b44a823089784abdece1d3e834ffaf7314a0f40a8a06"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac37b6f0df1cb93ae23a70dde31c9673b0aac0b366fe2880d0feacb512686634"
    sha256 cellar: :any,                 arm64_sequoia: "c524063272a90fbafbc1a11e67ea6901d61820fde8539553b8c1a0040826544b"
    sha256 cellar: :any,                 arm64_sonoma:  "8b5bc678eae2ab59e5b59a9823b1efe92c2f78fa44a3dad351e4487e588e9671"
    sha256 cellar: :any,                 sonoma:        "fe38b7fda6e6585d6bc9315f317adef9b620921147f7aaaef875f9b68020a743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94b225b1463e048b0a17916bd3a7079a8ab30d13a8c71cd1f70c2f5304a43d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6608cefb8585fe2ce651e784886f24077b39ef943954bd31872a8620d7a5730"
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