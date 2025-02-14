class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https:github.combokwoon95wgo"
  url "https:github.combokwoon95wgoarchiverefstagsv0.5.10.tar.gz"
  sha256 "acb42473d5deae4d8547d65d9883b4f1078f4eb5d6685947d48b0e86e67c29e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227623350f468bcf0a13ad63dad5647a91ba920c922f8b419d060fba0e3e4db8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "227623350f468bcf0a13ad63dad5647a91ba920c922f8b419d060fba0e3e4db8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "227623350f468bcf0a13ad63dad5647a91ba920c922f8b419d060fba0e3e4db8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2051aa123ab73bcfb867075133f821dd12da60f52af2833e3e7db9fa031d4af2"
    sha256 cellar: :any_skip_relocation, ventura:       "2051aa123ab73bcfb867075133f821dd12da60f52af2833e3e7db9fa031d4af2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2a0ca59c892f8138722d77f6762323bedc520e9fed60e0028dd622b290fa13"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}wgo -exit echo testing")
    assert_match "testing", output
  end
end