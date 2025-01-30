class Ipfs < Formula
  desc "Peer-to-peer hypermedia protocol"
  homepage "https:ipfs.tech"
  url "https:github.comipfskubo.git",
      tag:      "v0.33.0",
      revision: "8b657380277b79299dffe42993ec4f7de4a759d3"
  license all_of: [
    "MIT",
    any_of: ["MIT", "Apache-2.0"],
  ]
  head "https:github.comipfskubo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577d1bcd23f1dc68b98ad492f62d1df0a9630b65fa3fd4831f9822c367204d0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c93f94e9fb76c4e6824e089ef7190ff3510dd76fab1ad7f0f2ff339110587cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af16468db4aef232a177bd24653de8c75322d3d104f9e0eeaa7a613b6e4ac405"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cf83cd407ac92e2d365d868aebe4e59b2183b12c91fa7fab988c25eb22ece03"
    sha256 cellar: :any_skip_relocation, ventura:       "3ef45beb72ddfa1d16ec3114fe714cccfd67b9bbd9d0753aef31addd27acd8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b3e74559235fb78c0c7fb540f51dc47a42df8e330da21433185f25639440250"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "cmdipfsipfs"

    generate_completions_from_executable(bin"ipfs", "commands", "completion", shells: [:bash])
  end

  service do
    run [opt_bin"ipfs", "daemon"]
  end

  test do
    assert_match "initializing IPFS node", shell_output(bin"ipfs init")
  end
end