class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://ghproxy.com/https://github.com/bazelbuild/bazel/releases/download/6.3.0/bazel-6.3.0-dist.zip"
  sha256 "902198981b1d26112fc05913e79f1b3e9772c3f95594caf85619d041ba06ede0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebce89209ccfd88d370705da2a2d13e32e7e28fa452cbce08f77019bb0c3a87b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e0457b1c850a96d63903019d2813a2b097322c6c7f10c638546350cb5f4a83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "325758f5301369b8f72181eb976e7a81716ae87fb44fec403bc6bb398a4605a5"
    sha256 cellar: :any_skip_relocation, ventura:        "23ed294e1bcd3a35b08091b5fd15b2888bb25f698bd59fdf94d7c537b2f3b6a6"
    sha256 cellar: :any_skip_relocation, monterey:       "976cf3211c12521b167b905ef2f9a9884e6d26a0a81ef2fd8d5d3479e7e142bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbc69665367070e60fd9ca1dd1dc17aa647bfdc7ec5d4b38c97ef6bdd0349cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0a94e8b9a678ac3c5984cf72b2eccfeb74cb7aa8b931e61b3f5f58ac55a8f4b"
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