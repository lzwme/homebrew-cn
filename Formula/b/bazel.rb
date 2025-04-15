class Bazel < Formula
  desc "Google's own build tool"
  homepage "https:bazel.build"
  # TODO: Try removing `bazel@7` workaround whenever new release is available
  url "https:github.combazelbuildbazelreleasesdownload8.2.0bazel-8.2.0-dist.zip"
  sha256 "859bcdc655c2612a092b75e412082a34e2f1e47b643806de39be3e49c3cdc3f5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bd88817b4a5ec607993570dd95a63c923991064603c8fafadcab89013128cdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e547f741fcfc696668babe788910e4d52e474049b3c60b0b67eb570399430015"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8cc64084044ecc0441dd90750f23cfb1922113ad7be5e0507c5d87702fbd7f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "58500963b8ec169ca775535f23a95a688d1944b342a3e7855bd550592fc80f75"
    sha256 cellar: :any_skip_relocation, ventura:       "d9bc01acd4a61090b25a5541b0710be1901532fd377d21f86a16b7ca294c7f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9ba78bcffc64486ba909994c4763baa734231c6c4524960353fd62f9d2e3c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf890e5d1e219b9efb0a35616139b29efe43be066a3f64cc74c53e0b46e4f32b"
  end

  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  if DevelopmentTools.clang_build_version >= 1600
    depends_on "bazel@7" => :build

    resource "bazel-src" do
      url "https:github.combazelbuildbazelarchiverefstags8.2.0.tar.gz"
      sha256 "93afb85c2fc3aa9cedd57926a08c88a9b44c53916c732e43531a6f9c2a27e01a"

      livecheck do
        formula :parent
      end
    end
  end

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

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end
    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    (buildpath"sources").install buildpath.children

    cd "sources" do
      if DevelopmentTools.clang_build_version >= 1600
        # Work around an error which is seen bootstrapping Bazel 8 on newer Clang
        # from the `-fmodules-strict-decluse` set by `layering_check`:
        #
        #   externalabseil-cpp+abslcontainerinternalraw_hash_set.cc:26:10: error:
        #   module abseil-cpp+abslcontainer:raw_hash_set does not depend on a module
        #   exporting 'abslbaseinternalendian.h'
        #
        # TODO: Try removing when newer versions of dependencies (e.g. abseil-cpp >= 20250127.0)
        # are available in https:github.combazelbuildbazelblob#{version}MODULE.bazel

        # The dist zip lacks some files to build directly with Bazel
        odie "Resource bazel-src needs to be updated!" if resource("bazel-src").version != version
        rm_r(Pathname.pwd.children)
        resource("bazel-src").stage(Pathname.pwd)
        rm(".bazelversion")

        extra_bazel_args += %W[
          --compilation_mode=opt
          --stamp
          --embed_label=#{ENV["EMBED_LABEL"]}
        ]
        system Formula["bazel@7"].bin"bazel", "build", *extra_bazel_args, "src:bazel_nojdk"
        Pathname("output").install "bazel-binsrcbazel_nojdk" => "bazel"
      else
        system ".compile.sh"
      end

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