class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://ghproxy.com/https://github.com/quay/clair/archive/v4.7.0.tar.gz"
  sha256 "593b2bae3396f4593a6f8186d89a857a97536d57007ca87a1a6d30bbeed6e470"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a4f32c524c776f763eb19cc9f497bbbd02eb1e115f1568f600e3f34086effb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a4f32c524c776f763eb19cc9f497bbbd02eb1e115f1568f600e3f34086effb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a4f32c524c776f763eb19cc9f497bbbd02eb1e115f1568f600e3f34086effb2"
    sha256 cellar: :any_skip_relocation, ventura:        "da568ab2d3eae13103273c078eaf42e63b700155f092f2c9921ff8ec084987bd"
    sha256 cellar: :any_skip_relocation, monterey:       "da568ab2d3eae13103273c078eaf42e63b700155f092f2c9921ff8ec084987bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "da568ab2d3eae13103273c078eaf42e63b700155f092f2c9921ff8ec084987bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf06dd532bef208a25e845c918ffdb599f0e6fa39b858c7e926ae466618f4d54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/clair"
    (etc/"clair").install "config.yaml.sample"
  end

  test do
    http_port = free_port
    db_port = free_port
    (testpath/"config.yaml").write <<~EOS
      ---
      introspection_addr: "localhost:#{free_port}"
      http_listen_addr: "localhost:#{http_port}"
      indexer:
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      matcher:
        indexer_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
      notifier:
        indexer_addr: "localhost:#{http_port}"
        matcher_addr: "localhost:#{http_port}"
        connstring: host=localhost port=#{db_port} user=clair dbname=clair sslmode=disable
    EOS

    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "service initialization failed: failed to initialize indexer: failed to create ConnPool", output
  end
end