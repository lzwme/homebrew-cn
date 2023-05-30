class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://ghproxy.com/https://github.com/projectdiscovery/nuclei/archive/v2.9.5.tar.gz"
  sha256 "1a54899057f84cb6f837fb7e41db5cfdf6fdcebb79389e1d048f1f03d381bd00"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb1f85d650a1448b6a99393bea79a6c0b82826347a06d011a21ab83e7bbe16ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a35650bf6c01ba9d6feaeede1a939ae0c63275344104ef13a81c457877bea065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccf2ec4fe18cb91913797849a35c4b67a5271262c10823ea83ef59fa3f8e348c"
    sha256 cellar: :any_skip_relocation, ventura:        "7a98fa86c21daafef68584660d93f9b77b5b26238ae052b9c9cdfbc7489c2a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "cd8942b83e70b2ed22a3264409dcb6ea4e5d348e675db07d1fe908081cd51b6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "7315d492e2db79c4ff17b8d67f66234d6e048f1251575abc889b0d34c137c146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59d90947942731c684964c322d615484ee56e26f396bd055e0c10841656f3425"
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