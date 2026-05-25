class Fvm < Formula
  desc "Manage Flutter SDK versions per project"
  homepage "https://fvm.app"
  url "https://ghfast.top/https://github.com/leoafarias/fvm/archive/refs/tags/4.1.0.tar.gz"
  sha256 "44f24d6bef61f78fef509415bc8974fcd60c5ffe937f9a4d9b17fe26c55670a2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "306779d3a95581b6b0f9cc4540b42310d77f002e8957b0e7b9e5091506699247"
    sha256 cellar: :any,                 arm64_sequoia: "8a4cc0244dc98b62cef612361118a3e081bd4c28c7544645a2494903dab5c8fc"
    sha256 cellar: :any,                 arm64_sonoma:  "29d59fff6e21f2764e00aadda71d3f5c5b9401889dba35fe976fa31df41cf919"
    sha256 cellar: :any,                 sonoma:        "6eb237e35bc9eb8d145c3ced9e768ff6e07ea555ed70682446a4b51454b1701e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17a20c78703d90133b1570c1d017052194aa31caae7c2ff8e6baa6625c271017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd713c6000b8dc6e6311f9bcf27f570d759d3b6ee89078b91df05f302b9a2fc"
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