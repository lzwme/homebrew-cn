class Bazel < Formula
  desc "Google's own build tool"
  homepage "https:bazel.build"
  url "https:github.combazelbuildbazelreleasesdownload7.4.1bazel-7.4.1-dist.zip"
  sha256 "83386618bc489f4da36266ef2620ec64a526c686cf07041332caff7c953afaf5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc775623baab8f83e293d5c9a15b2f264e8bbfc6985b9b0d34d675b1eca10604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9769c3905214d37bc33ee022130d3eb53cf79332798f0d95b6fec7468d249ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c067b18f9ee1ef0a165bc868cb7a400c186bdc80025b84684e00f24057fad73"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4325cabb79e0f12b6c0cd0a549f869213c95c76e75bd7f9c1d35f8a6ef13b31"
    sha256 cellar: :any_skip_relocation, ventura:       "d78d5d6463d35c897e1c56fe52a358108b8d9150e3249e5345161a565aa4dafa"
  end

  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel .compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath"work"
    # Force Bazel to use openjdk@21
    ENV["EXTRA_BAZEL_ARGS"] = "--tool_java_runtime_version=local_jdk"
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    # Force Bazel to use Homebrew python
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec"bin"

    # Bazel clears environment variables other than PATH during build, which
    # breaks Homebrew's shim scripts that need HOMEBREW_* variables.
    # Bazel's build also resolves the realpath of executables like `cc`,
    # which breaks Homebrew's shim scripts that expect symlink paths.
    #
    # The workaround here is to disable the shim for CC++ compilers.
    ENV["CC"] = "usrbincc"
    ENV["CXX"] = "usrbinc++" if OS.linux?

    (buildpath"sources").install buildpath.children

    cd "sources" do
      system ".compile.sh"
      system ".outputbazel", "--output_user_root",
                               buildpath"output_user_root",
                               "build",
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scriptspackagesbazel.sh" => "bazel"
      ln_s libexec"binbazel-real", bin"bazel-#{version}"
      (libexec"bin").install "outputbazel" => "bazel-real"
      bin.env_script_all_files libexec"bin", Language::Java.java_home_env("21")

      bash_completion.install "bazel-binscriptsbazel-complete.bash"
      zsh_completion.install "scriptszsh_completion_bazel"
      fish_completion.install "bazel-binscriptsbazel.fish"
    end
  end

  test do
    touch testpath"WORKSPACE"

    (testpath"ProjectRunner.java").write <<~JAVA
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    JAVA

    (testpath"BUILD").write <<~EOS
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin"bazel", "build", ":bazel-test"
    assert_equal "Hi!\n", pipe_output("bazel-binbazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `toolsbazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath"tools""bazel").write <<~EOS
      #!binbash
      echo "stub-wrapper"
      exit 1
    EOS
    (testpath"toolsbazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}bazel-#{version} --version")
  end
end