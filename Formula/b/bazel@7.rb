class BazelAT7 < Formula
  desc "Google's own build tool"
  homepage "https:bazel.build"
  url "https:github.combazelbuildbazelreleasesdownload7.6.0bazel-7.6.0-dist.zip"
  sha256 "79028d077f06f33883ba8af3a23e519defc36502f6da67952eb74ad33ec1d852"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(7(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e453cd993e64629450a3a3e478979c05f2e4864b99daf516518b3fc92aee738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d866fb4b90d160181f6529a2687b8f26a40aaa04bf4c1bcbcd12e23ed9d154cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e53ccebe65c45c2b62dbdbff3bfd7c8cac8c08d0853337263f717c38f2649a31"
    sha256 cellar: :any_skip_relocation, sonoma:        "83545e7004c529220df9dadd2e9338f40bebefc1002132db88ec00aa717edcec"
    sha256 cellar: :any_skip_relocation, ventura:       "0d494e39573cbac4b906a037794c366014510a4b020a0c87ae98cf8a67ec04fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c6d9d99e930795f0103529875895bcf018a757b19ca83709b5841bf4a499d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a18f41a81c58b984e587879fcd60ea6f9dd24908db341d598e2e4f5953c1b072"
  end

  keg_only :versioned_formula

  # https:bazel.buildrelease#support-matrix
  deprecate! date: "2027-01-01", because: :unsupported

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

    system bin"bazel", "build", ":bazel-test"
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