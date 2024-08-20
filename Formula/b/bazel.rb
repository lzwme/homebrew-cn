class Bazel < Formula
  desc "Google's own build tool"
  homepage "https:bazel.build"
  url "https:github.combazelbuildbazelreleasesdownload7.3.1bazel-7.3.1-dist.zip"
  sha256 "f0501f90c9fc74cd6933dbdc59e17b8d6272d6c09f8b8e3c428985c5897147c7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca0f722957460ccfecf2f2549f1676399ea3e9b684fc28bf8c42781df97f9f19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f67b5cbf284cfaa1453cfbd19716b68d96f701fd942a32168a4acf2c30ebb3fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f736e0d8aca2d7d35aa45d9f25d716a95aeaf83a773816b316e9353aea5d42a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4941ebaa62b2381655ae80328a147411ef42f08d39d009422b3e46dda4786041"
    sha256 cellar: :any_skip_relocation, ventura:        "8e00c48499edb5d2dbc15ea435178c077d8b22b3eb9afe97b64c0e4ca84478b1"
    sha256 cellar: :any_skip_relocation, monterey:       "d1b8f1cd880b4656ded204763f583443cc06655dc9373c92597f6142c9f04b7e"
  end

  depends_on "python@3.12" => :build
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
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec"bin"

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

    (testpath"ProjectRunner.java").write <<~EOS
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

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