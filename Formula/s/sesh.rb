class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https:github.comjoshmedeskisesh"
  url "https:github.comjoshmedeskisesharchiverefstagsv2.14.0.tar.gz"
  sha256 "7629869620aa2b496262c51511be20660579ae94baf1e2ea82af8dcbde3ab4db"
  license "MIT"
  head "https:github.comjoshmedeskisesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4a08f14ff0f13d1a09029e3f368711056be1285e67417183c818e16faa45b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4a08f14ff0f13d1a09029e3f368711056be1285e67417183c818e16faa45b4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4a08f14ff0f13d1a09029e3f368711056be1285e67417183c818e16faa45b4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "572bebaa4fba4afc9ce8c6cdf7e78aae8e9d579dd73e2c0a656185dc100f2c87"
    sha256 cellar: :any_skip_relocation, ventura:       "572bebaa4fba4afc9ce8c6cdf7e78aae8e9d579dd73e2c0a656185dc100f2c87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b04bbb41e606e1f258b25a8af3f1b542bcf30eda615656571e648e6bb4c8802"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}sesh --version")
  end
end