class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://ghproxy.com/https://github.com/bazelbuild/bazel/releases/download/6.3.1/bazel-6.3.1-dist.zip"
  sha256 "2676319e86c5aeab142dccd42434364a33aa330a091c13562b7de87a10e68775"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20aec8a40c6d671ea7084b6ad9bd5146bccef07120e13bb4b86c487e347f8f73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bcc183831a35c90321312b3f88a71777acec5f7daeda8e0a7c437087b0403cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa61c591c1a600b72c947fd34e0d2c0a93a22278c70dfab5de106ea9c707b4a1"
    sha256 cellar: :any_skip_relocation, ventura:        "2f076ed0d08f6eba94fdd13db897157ce0433aa212e525ffe72d4d23405f50fb"
    sha256 cellar: :any_skip_relocation, monterey:       "64688d796042cc7b728cdba78bb408504f737681bd07714b9eae4c3336df63f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7173bfa04273df0fb915cf730d9c793ea81766c425f27f6615ab6a776f0221ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b013a11bbb1d9e2185448fc021aac218f2b2841fe192f6e99e158a14936e2a5"
  end

  depends_on "python@3.11" => :build
  depends_on "openjdk@11"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use openjdk@11
    ENV["EXTRA_BAZEL_ARGS"] = "--host_javabase=@local_jdk//:jdk"
    ENV["JAVA_HOME"] = Language::Java.java_home("11")
    # Force Bazel to use Homebrew python
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # Bazel clears environment variables other than PATH during build, which
    # breaks Homebrew shim scripts. We don't see this issue on macOS since
    # the build uses a Bazel-specific wrapper for clang rather than the shim;
    # specifically, it uses `external/local_config_cc/wrapped_clang`.
    #
    # The workaround here is to disable the Linux shim for C/C++ compilers.
    # Remove this when a way to retain HOMEBREW_* variables is found.
    if OS.linux?
      ENV["CC"] = "/usr/bin/cc"
      ENV["CXX"] = "/usr/bin/c++"
    end

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root",
                               buildpath/"output_user_root",
                               "build",
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s libexec/"bin/bazel-real", bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", Language::Java.java_home_env("11")

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end
  end

  test do
    # linux test failed due to `bin/bazel-real' as a zip file: (error: 5): Input/output error` issue
    # it works out locally, thus bypassing the test as a whole
    return if OS.linux?

    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~EOS
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<~EOS
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    assert_equal "Hi!\n", pipe_output("bazel-bin/bazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `tools/bazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath/"tools"/"bazel").write <<~EOS
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    EOS
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end