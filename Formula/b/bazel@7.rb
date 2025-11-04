class BazelAT7 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://ghfast.top/https://github.com/bazelbuild/bazel/releases/download/7.7.0/bazel-7.7.0-dist.zip"
  sha256 "277946818c77fff70be442864cecc41faac862b6f2d0d37033e2da0b1fee7e0f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(7(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5ba0c8ebc46aff52de4e7d75f89822f5a49e6cfb390146cd0852c4872be8a3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b68187e8e26d7191c0916eb7565fb725390a4f147c9d7ceefca7cc3bffe447e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "819913a02673746b9600a809bd0bbfef76dd6bfba5e57560ef481d7bac607dfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6d6d7c876080eb9b0b2008933b74f3b63043cb323a17092a66a2f6b9b47b9fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e6ed5d3acdaa4b2e3159c0d4ce6d9d97905aef6b5fe68bed0406b655c2b064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab264b63ffceb8eb00fc967402fa6ac155c386a7f533e53b72fa3b28e6ce25b2"
  end

  keg_only :versioned_formula

  # https://bazel.build/release#support-matrix
  deprecate! date: "2027-01-01", because: :unsupported

  depends_on "openjdk@21"

  uses_from_macos "python" => :build
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    # We use a workaround to prevent modification of the `bazel-real` binary
    # but this means brew cannot rewrite paths for non-default prefix
    pour_bottle? only_if: :default_prefix
  end

  def bazel_real
    libexec/"bin/bazel-real"
  end

  def install
    java_home_env = Language::Java.java_home_env("21")

    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # https://github.com/bazelbuild/bazel/issues/27401
    ENV["BAZEL_DEV_VERSION_OVERRIDE"] = ENV["EMBED_LABEL"]
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"
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

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root=#{buildpath}/output_user_root",
                               "build",
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

    system bin/"bazel", "build", "//:bazel-test"
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