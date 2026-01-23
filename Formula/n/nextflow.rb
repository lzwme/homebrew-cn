class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://ghfast.top/https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.10.3.tar.gz"
  sha256 "1cc3da461bc3c19df7ec945937048891fcc5ef3ac5170cae7d09ef8cd2b70275"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67915e659e868e9ef3bf2c5abab05f1cfad5fe081b040546c4e47f9d63655976"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccaa95ca3ab2109459ef4c8aa634a8fab66719782b9f4cc2b1f5de03e455867f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b77677510103b07a6f795bf8ca82c05dd3284f47aad80771e7ff0e223cbcd813"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73b969a3f7e1f3504694048590ceaa812738e0efede73c5c716be46d242ddab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "870c4cd8b55dda9e7352e86f58ad4d809b135879fd01ac86e860ded1b253279c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b46f401d528aa547b90370bbaf9d9d1ae11c42fd9d7665d9f6f7325180b04607"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env
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