class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel/releases/download/8.4.1/bazel-8.4.1-dist.zip"
  sha256 "c434966629e32ba370741f95f5434a8f0b5279a87991d883a354476e8062565f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8146f1788730e24195853ff59338e781c1b8f53f2a695e88e136094fd000d555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f8d77fb595ac904e99eb9477767f91af35d5ca865e0b33c90efa1dba12fb07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "199040fea7ec859df31cc65a1641c8c6ff213994eb2a95a40a930207c0e4c201"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7af9dc7bed407258befd49445139d8aafe6b38b4ca510f400952cd07cb865b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "591e0668176cf21218463b839cef37df2873ec6b085ed7f3f4e20cb4dccab190"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b52183ffab2218a8cafb27bb4220e78f8a6be8d08b24f45a0051e55c545586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "073a04829902099d2b6e85a1e1eba60f801fe2e51aed44d7a2477371014569a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d784c1ac4555722200d3bfd78eba38db1f0842083ddfa27bc8c1758cc483d2fa"
  end

  depends_on "python@3.13" => :build
  depends_on "openjdk@21"

  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    on_arm do
      # Workaround for "/usr/bin/ld.gold: internal error in try_fix_erratum_843419_optimized"
      # Issue ref: https://sourceware.org/bugzilla/show_bug.cgi?id=31182
      depends_on "lld" => :build

      # We use a workaround to prevent modification of the `bazel-real` binary
      # but this means brew cannot rewrite paths for non-default prefix
      pour_bottle? only_if: :default_prefix
    end
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  conflicts_with "bazelisk", because: "Bazelisk replaces the bazel binary"

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    # Backport newer apple_support to build LC_UUID needed by Tahoe
    # https://github.com/bazelbuild/bazel/commit/ccd3f68dc8c0bf7fc7be8c03dd070a7672e4f2b2
    inreplace "MODULE.bazel", '"apple_support", version = "1.18.1"', '"apple_support", version = "1.21.0"'
    inreplace "MODULE.bazel.lock" do |s|
      s.gsub! '/1.18.1/MODULE.bazel": "019f8538997d93ac84661ab7a55b5343d2758ddbff3a0501a78b573708de90b4"',
              '/1.21.0/MODULE.bazel": "ac1824ed5edf17dee2fdd4927ada30c9f8c3b520be1b5fd02a5da15bc10bff3e"'
      s.gsub! '/1.18.1/source.json": "fcfd4548abb27da98f69213a04a51cf7dab7c634f80795397f646056dab5f09f"',
              '/1.21.0/source.json": "028d7c853f0195e21b1323ffa2792e8fc5600da3fdaaff394fe932e0e04a4322"'
    end

    # Workaround for "missing LC_UUID load command in .../xcode-locator"
    # https://github.com/bazelbuild/bazel/pull/27014
    inreplace "tools/osx/BUILD", " -Wl,-no_uuid ", " "

    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
    # Force Bazel to use brew OpenJDK
    extra_bazel_args = ["--tool_java_runtime_version=local_jdk"]
    ENV.merge! java_home_env.transform_keys(&:to_s)
    # Bazel clears environment variables which breaks superenv shims
    ENV.remove "PATH", Superenv.shims_path

    # Workaround to build zlib < 1.3.1 with Apple Clang 1700
    # https://releases.llvm.org/18.1.0/tools/clang/docs/ReleaseNotes.html#clang-frontend-potentially-breaking-changes
    # Issue ref: https://github.com/bazelbuild/bazel/issues/25124
    if DevelopmentTools.clang_build_version >= 1700
      extra_bazel_args += %w[--copt=-fno-define-target-os-macros --host_copt=-fno-define-target-os-macros]
    end

    # Set dynamic linker similar to cc shim so that bottle works on older Linux
    if OS.linux? && build.bottle? && ENV["HOMEBREW_DYNAMIC_LINKER"]
      extra_bazel_args << "--linkopt=-Wl,--dynamic-linker=#{ENV["HOMEBREW_DYNAMIC_LINKER"]}"
    end

    if OS.linux? && Hardware::CPU.arch == :arm64
      extra_bazel_args << "--linkopt=-fuse-ld=lld"
      extra_bazel_args << "--host_linkopt=-fuse-ld=lld"
    end

    ENV["EXTRA_BAZEL_ARGS"] = extra_bazel_args.join(" ")

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root=#{buildpath}/output_user_root",
                               "build",
                               *extra_bazel_args,
                               "scripts:bash_completion",
                               "scripts:fish_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      ln_s bazel_real, bin/"bazel-#{version}"
      (libexec/"bin").install "output/bazel" => "bazel-real"
      bin.env_script_all_files libexec/"bin", java_home_env

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash" => "bazel"
      zsh_completion.install "scripts/zsh_completion/_bazel"
      fish_completion.install "bazel-bin/scripts/bazel.fish"
    end

    # Workaround to avoid breaking the zip-appended `bazel-real` binary.
    # Can remove if brew correctly handles these binaries or if upstream
    # provides an alternative in https://github.com/bazelbuild/bazel/issues/11842
    if OS.linux? && build.bottle?
      Utils::Gzip.compress(bazel_real)
      bazel_real.write <<~SHELL
        #!/bin/bash
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
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~JAVA
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    JAVA

    (testpath/"BUILD").write <<~STARLARK
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    STARLARK

    # Explicitly disable repo contents cache
    system bin/"bazel", "build", "//:bazel-test", "--repo_contents_cache="
    assert_equal "Hi!\n", shell_output("bazel-bin/bazel-test")

    # Verify that `bazel` invokes Bazel's wrapper script, which delegates to
    # project-specific `tools/bazel` if present. Invoking `bazel-VERSION`
    # bypasses this behavior.
    (testpath/"tools/bazel").write <<~SHELL
      #!/bin/bash
      echo "stub-wrapper"
      exit 1
    SHELL
    (testpath/"tools/bazel").chmod 0755

    assert_equal "stub-wrapper\n", shell_output("#{bin}/bazel --version", 1)
    assert_equal "bazel #{version}-homebrew\n", shell_output("#{bin}/bazel-#{version} --version")
  end
end