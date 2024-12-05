class Thanos < Formula
  desc "Highly available Prometheus setup with long term storage capabilities"
  homepage "https:thanos.io"
  url "https:github.comthanos-iothanosarchiverefstagsv0.37.1.tar.gz"
  sha256 "0c232ec85cc34338c10a1314b4bdb7f74e98bba0012545b9186a210f567276e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0a534ed1d2f074f1075904484c1bd9a225ffa865a364c07e049908c8b7391c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c938143e8f19ffa91b3c8c74acbe9e8d3bafa917e7e874d3e69298161c8339f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae57e44944a27551d7a1e2281b96a6130967d1663e7199f38a1de8b7a076132a"
    sha256 cellar: :any_skip_relocation, sonoma:        "66170c78abe5a4932dbf2fadda5bc204936c8eba30a622af033d0c864c419659"
    sha256 cellar: :any_skip_relocation, ventura:       "9b222a355a27a323626e19b1559408adc03d60bc2bfb84db981ae707ce94433b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0dfa73dbb5d51e4634368265221e12bb0f580cf147cd8b6ff73b129db96df08"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdthanos"
  end

  test do
    (testpath"bucket_config.yaml").write <<~YAML
      type: FILESYSTEM
      config:
        directory: #{testpath}
    YAML

    output = shell_output("#{bin}thanos tools bucket inspect --objstore.config-file bucket_config.yaml")
    assert_match "| ULID |", output
  end
end