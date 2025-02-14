class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.29.7.tar.gz"
  sha256 "967d5ec67f7e58b4eb443c975ec8597d173b6d519b6a2fc908a449236219c11a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15ffbd66e15aa0461cc458bff866b95ef130292fb48756423417d7d02d7d4956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8323b5722711efda957157c4e376989613778a611323abe15cc2c3a8a27172"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "357078435c478ac7c51b55d4ff5e2cf0962e7bd6e14f6d5b43c3f980e51eac26"
    sha256 cellar: :any_skip_relocation, sonoma:        "40115eef86fd6fab55f48a941c98565d115dc8d12a7d719d456367c21259fe5b"
    sha256 cellar: :any_skip_relocation, ventura:       "f901c87859ab83113da70635ec7e42cfd2f532e86fd3ca7c9ec2eea532916df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "154075bde5f3643d6772d3302864cb975856e356542aaa29973979933ed2b093"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end