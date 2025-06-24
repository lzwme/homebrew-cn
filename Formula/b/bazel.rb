class Bazel < Formula
  desc "Google's own build tool"
  homepage "https:bazel.build"
  url "https:github.combazelbuildbazelreleasesdownload8.3.0bazel-8.3.0-dist.zip"
  sha256 "c81cbf1a4d26cfb283c26c3544d47828679e42476e32e807151b9f647207530c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "132326dd57f0f5a0e42ebd8a712863904296eb7f42bc1fe4df38c6eb4a003fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0972cff8ccb60757427904c1e18e4ffc1dd7f8fe6699ca672b62db37c81e440"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c66f1bb88fb1851976e625b89aef13b3c7e0585d3ad3550b7ce3a131dd586bb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "29c3085e845ee639486a98fc0adbb5d870598e0279dbb54476976240a79fbb90"
    sha256 cellar: :any_skip_relocation, ventura:       "27ab02a58fcb0852b44ed15f77480615fd68e98dff6823b26e179999673bf0bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28fc3f08ef33761901bf81ac5ce4f0750a9508cad1b9558d86e8c2037e22f235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b53e7336f1f689b457ecc2b772489aa53c9730e1530fee9048f586b999bd02c1"
  end

  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    on_intel do
      # We use a workaround to prevent modification of the `bazel-real` binary
      # but this means brew cannot rewrite paths for non-default prefix
      pour_bottle? only_if: :default_prefix
    end
  end

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def bazel_real
    libexec"binbazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel .compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath"work"
    # Force Bazel to use brew OpenJDK
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Workaround to build zlib < 1.3.1 with Apple Clang 1700
    # https:releases.llvm.org18.1.0toolsclangdocsReleaseNotes.html#clang-frontend-potentially-breaking-changes
    # Issue ref: https:github.combazelbuildbazelissues25124
    if DevelopmentTools.clang_build_version >= 1700
      extra_bazel_args += %w[--copt=-fno-define-target-os-macros --host_copt=-fno-define-target-os-macros]
    end

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    (buildpath"sources").install buildpath.children

    cd "sources" do
      system ".compile.sh"
      system ".outputbazel", "--output_user_root=#{buildpath}output_user_root",
                               "build",
                               *extra_bazel_args,
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scriptspackagesbazel.sh" => "bazel"
      ln_s bazel_real, bin"bazel-#{version}"
      (libexec"bin").install "outputbazel" => "bazel-real"
      bin.env_script_all_files libexec"bin", java_home_env

      bash_completion.install "bazel-binscriptsbazel-complete.bash" => "bazel"
      zsh_completion.install "scriptszsh_completion_bazel"
      fish_completion.install "bazel-binscriptsbazel.fish"
    end

    # Workaround to avoid breaking the zip-appended `bazel-real` binary.
    # Can remove if brew correctly handles these binaries or if upstream
    # provides an alternative in https:github.combazelbuildbazelissues11842
    if OS.linux? && build.bottle?
      Utils::Gzip.compress(bazel_real)
      bazel_real.write <<~SHELL
        #!binbash
        echo 'ERROR: Need to run `brew postinstall #{name}`' >&2
        exit 1
      SHELL
      bazel_real.chmod 0755
    end
  end

  def post_install
    if File.exist?("#{bazel_real}.gz")
      rm(bazel_real)
      system "gunzip", "#{bazel_real}.gz"
      bazel_real.chmod 0755
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

    (testpath"BUILD").write <<~STARLARK
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    STARLARK

    # Explicitly disable repo contents cache
    system bin"bazel", "build", ":bazel-test", "--repo_contents_cache="
    assert_equal "Hi!\n", shell_output("bazel-binbazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `toolsbazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath"toolsbazel").write <<~SHELL
      #!binbash
      echo "stub-wrapper"
      exit 1
    SHELL
    (testpath"toolsbazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}bazel-#{version} --version")
  end
end