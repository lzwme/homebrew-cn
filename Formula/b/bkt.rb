class Bkt < Formula
  desc "CLI utility for caching the output of subprocesses"
  homepage "https:www.bkt.rs"
  url "https:github.comdimo414bktarchiverefstags0.8.1.tar.gz"
  sha256 "c8c8cc6f03d0fd35c4ace0ad81e437c41c6bb7778f5caafb3dbb1904b2b0c4f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9b11cb72eee4a2791a5accc9d325934004dcc97f741d18530a19f0d93e5d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94b062a26c16243e7131ba960a751c69320a2ca2a181ce8e56cfbf49fc53c88d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31bd800e3d07048d1938701bcbc12a81222eaebfa5c2654585774defefab93e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "724039c2d9082e63585935895e54396f079440eaec8a0bbc8b142a6c5b38a524"
    sha256 cellar: :any_skip_relocation, ventura:       "7543fed4a370c38f58147c1664c3f3533b9b1d1b4614bd70be908150e447e206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769d5594fd70d6e6e0294999a6ff4c09bea44e3625dcc0cfd13ad62358e39543"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}bkt --ttl=1m -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}bkt --ttl=1m -- date +%s.%N")
  end
end