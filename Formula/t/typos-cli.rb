class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.33.1.tar.gz"
  sha256 "ba79bbce57416d0cab7805f2854581ed2f34be80889c25c2a47dd85bdc3d0d46"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42636dee905d8afa39334c7ae0c70fb913cd748da9e272c46ac1e662718db3f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f65e3e5de594cbe2f718719b2bf9629ac31cd2da216aeecea3f2497808e4b80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e766b42df2413fe9a43cdee2f69aa2f93a693717362f77f049f7e83f137c3b5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a52c68135cfd4b80ff09da880f08b78789e3c94d4e95a7d31722e243a039ed"
    sha256 cellar: :any_skip_relocation, ventura:       "98d6a4ea95c917030a8906b0c965f35b6fd0dbe577011c16f09d60e4211d1862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8579aae6e196a38dee6df6db4e46a06246f184e82c3893fc435666d361d88c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d35dbf9a86e4b46f01647bc80cfc4bee89cb1e491f8f3c3fa4eb5fe97a5af36d"
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