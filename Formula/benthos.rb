class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://ghproxy.com/https://github.com/benthosdev/benthos/archive/v4.14.0.tar.gz"
  sha256 "0711257ff43649c31cf45848767dc124d73c4b2edd9d0e5335d8803c62d73889"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abe54d92e8e312fa007e7c0beda12037f39c95e0038f379a09d677f7246c6cc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf2a3921d698907b8c043f171430f076f0d0dd3dbd9994f9475bed754d55bdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c14675521a080fd7186bc8ac8ca26eadbfe5bb00316d0a02688ffaf827d84613"
    sha256 cellar: :any_skip_relocation, ventura:        "96734ac06e8ce72c78c02dfb66b351d7f0dabde9ccf112f1e32b1999b6fa1e8f"
    sha256 cellar: :any_skip_relocation, monterey:       "b41741073604ab168d57d2fb049c661e4066839ca460b356de0debf8f074475c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e114ce2ab009fccdbf4200d2653ed178828433c460659ea5d07e0b51122d54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5fa1331eb74b9bff95a15ccec8b13663654d7d5bc12ad291233017b17cb12e9"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end