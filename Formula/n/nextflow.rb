class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.7.tar.gz"
  sha256 "1d54ac5966fcf4d91101d20210f52e0c96fb64e68f4c006ae3162fa37e9b5d14"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35e1e0612e6fbb98eb949a59aa81f4a9123c2551dc5e0a0914a4777e4d43ae07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd91f6ec8cd163b7c3d07895ba2275bcc5aec38de02ca4b96661e28ee96e25bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "529dce00e722131a4902da5e63980fbfcc767526a5f0132967659dea3febe15b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "55ef614829767149746f6358a5e5702de2dd5be654e6d1951ac451a92b3df478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7f683ba59589873dfc3dd1ec618bd447013a58987e4ad4c66a1c0467e2a20611"
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