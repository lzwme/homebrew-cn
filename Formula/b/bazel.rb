class Bazel < Formula
  desc "Google's own build tool"
  homepage "https:bazel.build"
  url "https:github.combazelbuildbazelreleasesdownload7.4.0bazel-7.4.0-dist.zip"
  sha256 "198d70bb73b93bb2b630c26feb08c4f832e7520c2390776672a853d68f46f428"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4c711bbf985648069cca286d256c6d116ba6c73db416864e686c5da6f449cb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d26ffe31e03231f75d41e0b2c0abfa30ae7a384d4df06dfaf309fbc2a08e252b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60f47d339c1e2b02a45c4fc46f450a1720f18e169d3214e464bb5a2248113f66"
    sha256 cellar: :any_skip_relocation, sonoma:        "666deb365e5e9eb0e59385eae0fa23fa3f69dd5f8686be626dd5b51486912704"
    sha256 cellar: :any_skip_relocation, ventura:       "e6bbedc9fa932259ef674ba860fb0775fc26b00a49905b32d383a3f351dce04c"
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