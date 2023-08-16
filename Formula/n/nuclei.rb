class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/v2.9.10.tar.gz"
  sha256 "34f8846f39358b9b3f97d543f3eb26a9aa01fe92f4aea3ea1c83349b70abcd05"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc159074afc963883f0d7d9b8e51727e3e6c0ed7d2211112781eba6029c1437b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199ea8e0daa8472e3c696cd65260d7e68f9e03ff08f42739d6c88e655df1086b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1af0919d8553bfe15956597f842e1a3eef7795744309988bacecd4e8f8f4f9d"
    sha256 cellar: :any_skip_relocation, ventura:        "eaf914ea722cec4f1deab51cf03afb2458ad65fc99920ba29ff0d92447a94f79"
    sha256 cellar: :any_skip_relocation, monterey:       "9490b3aef00437f78dd761c4cfeda9920be238407656866dade005ee9b605f24"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7023b3552c5ce6ba250d2659870364a8f9a2c2f8ab0797a27f38b24a79a0602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c45097e6c613e88ef44c3abc12fb34eda2ba47df37eda8997d791ac8b2dc34d2"
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