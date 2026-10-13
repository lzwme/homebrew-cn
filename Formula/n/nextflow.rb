class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.10.0.tar.gz"
  sha256 "e4882e79511c4025f6687b823b3efa9090d1f7dcc227629f4383110390241c8f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0c597baeb7b3b34fa89ac9ec64e8be02b42c1e9413a43b2657befc97d202fc7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1022720fbf7a27e97732c5ea2204e41488859cdd9194f4a3d6e618de0684b40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ead13cda046c59c48e94809f840132e1d68f4aaca9678d669b1340ef81c25cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c62e3ea19443bde3470abf34a217156d0a4f0f4286839dc8bae549fa5753a14c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "17e9c2055802cbffbbbc544e33f2b49d3a5d3391fb3177324fd60f790441676b"
  end

  depends_on "gradle" => :build
  # TODO: Switch back to `openjdk` once Nextflow supports JDK 27: 26.04.6 documents
  # "Java 17 (or later, up to 26)" and fails with "Unsupported class file major version 71".
  # https://www.nextflow.io/docs/latest/install.html#requirements
  depends_on "openjdk@25"

  def install
    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env("25")
  end

  test do
    (testpath/"hello.nf").write <<~NF
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
    NF

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end