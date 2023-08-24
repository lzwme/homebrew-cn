class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.13.2.tar.gz"
  sha256 "276529e504b0dda861a12ffa0a84c30d7947c4aac275cbbdd70e1c2c78315802"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a719631fbf940835ac4e13ff57270a714b5ecf7a1100fad7cfee4c7eac5a477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "480f969e934a4d087511e13c450796396626251be29bc4b40b2b5751d2a200b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ad2e0a3352764a9d5766d371a491bb3911a2566fba877c1a4ea5faebb81dfec"
    sha256 cellar: :any_skip_relocation, ventura:        "3a7556e68c99faa57ab8ec21a6f6e83d1eaafcbdf51f6c3435f8eb3b7d843453"
    sha256 cellar: :any_skip_relocation, monterey:       "94ed7800d82216db9745e52233a1b67b8598b3d7e86a14b97c0083bf0c8bec90"
    sha256 cellar: :any_skip_relocation, big_sur:        "c128881744879c2b26a2403e7a27c85350ce6ff06d60d04247849d293c5c7724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a4e5b02201442dee5e8cb48691109fc0ce0dfaa2e6c2dd8b2901e7d7b559dfa"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end