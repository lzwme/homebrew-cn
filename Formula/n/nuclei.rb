class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/v2.9.12.tar.gz"
  sha256 "b8496436e2ec608c28b3eb3137c1385e9b1bb7a5178b7a8de2a551853e234fd1"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "624ff5526990a790078af608691f70c8f4e0b393ad70a8bc779221cc49a5a523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5ba0e9fb1da3c26f224f7832b2b35e4b048468785c905cc17b9031458d26798"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efbcfef4cc3298c0058894469c5a9c5ef9b0442aba79a3eabe76c306667464ac"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd05cbf44c7f4433974a9f4d67039f4b7632b9a28921dbc0902dd7099b8d06b"
    sha256 cellar: :any_skip_relocation, monterey:       "d2c0bb49df4a8d348eb73d68e9543000a0c974b5d99a330bd74f31490187995c"
    sha256 cellar: :any_skip_relocation, big_sur:        "324e85962c564426a149b14bf41ad1822f9bfe9f4507a93d18f4e0d124fa9f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0b24cc5e9955f254f3bec201ac9c0634fba09846b163198610c6c698b41d975"
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: "{{FQDN}}"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - "IN\tA"
    EOS
    system bin/"nuclei", "-target", "google.com", "-t", "test.yaml", "-config-directory", testpath
  end
end