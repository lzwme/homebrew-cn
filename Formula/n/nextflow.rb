class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  # TODO: Check if we can use `openjdk` 25+ when bumping the version.
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.8.tar.gz"
  sha256 "56883ccbfb0d8ad786c2c4a38b379aa3db2963248ccf6056a17ea9fcd61cc407"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11b7da95ac1c29791aefc6bfcf78080e2ad22e163acae7b47aa801b370a627bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c579fc43e3228347df9fc19fdc0d14f2032d9aaa4b2362b0875d123e7357508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3040aec77bc02247e282c6334825e25a8131d6b6320dcef2b67c94b694b5d906"
    sha256 cellar: :any_skip_relocation, sonoma:        "8713354c645af039d11e468bdad6043f7fff048e73d0ba839fdf052e5a169a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "960825f509660273808f677856fc59d862851ac7e3d40c3fc349935a2956296e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad10034c0721e0ea2bee3b62ca5f69a0d93e9d43f2ed586a39b413e8f23458e"
  end

  depends_on "gradle" => :build
  # https://github.com/nextflow-io/nextflow/blob/master/docs/install.md#requirements
  depends_on "openjdk@21"

  def install
    # update Foojay plugin for gradle 9 compatibility, upstream pr ref, https://github.com/nextflow-io/nextflow/pull/6388
    inreplace "settings.gradle", "0.7.0", "1.0.0"

    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env("21")
  end

  test do
    (testpath/"hello.nf").write <<~EOS
      process hello {
        publishDir "results", mode: "copy"

        output:
        path "hello.txt"

        script:
        """
        echo 'Hello!' > hello.txt
        """
      }
      workflow {
        hello()
      }
    EOS

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end