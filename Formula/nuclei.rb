class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/v2.9.9.tar.gz"
  sha256 "069a1682fe1202891555de5c18e59ba2450d6d4d669d6d51442d1d9695e23c49"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "645d2e601750049f0640a599a82d01cb7104d7fff0774efdf20633cd61c26b96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee32b265147ba96160f4ee4355fafe05d67f45f5800f44304c728de7578943f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54c4413cfaa4b84c3058bfeda9352388280a7650b6f59d1a4ef95ffa703f47c8"
    sha256 cellar: :any_skip_relocation, ventura:        "8ad488dab5f53f563d7feea1e9ea060fcb42da27cd64cab3dcd553cdb924b6dc"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a5066f794c64455e53652e7df0772e7abc79cfa5ba168840934adcb3469dba"
    sha256 cellar: :any_skip_relocation, big_sur:        "f373b12d9aa89da7b382533832b65e9930430d8f52c55fe441473c83416242d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2841e8e6dde1d743c38e89050593b118bee56e5030ea067e769eeebe419c8996"
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