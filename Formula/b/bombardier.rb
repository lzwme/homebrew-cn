class Bombardier < Formula
  desc "Cross-platform HTTP benchmarking tool"
  homepage "https:github.comcodesenbergbombardier"
  url "https:github.comcodesenbergbombardierarchiverefstagsv2.0.1.tar.gz"
  sha256 "ecab7b58a5f7fbb74ca390e3256522243087a7ad41f167eead8a62b4c19c12a8"
  license "MIT"
  head "https:github.comcodesenbergbombardier.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca2757dea44a23cc24a96ac00bf997e4346c7eb6ba6d4a7d1101c1c0590a788c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca2757dea44a23cc24a96ac00bf997e4346c7eb6ba6d4a7d1101c1c0590a788c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca2757dea44a23cc24a96ac00bf997e4346c7eb6ba6d4a7d1101c1c0590a788c"
    sha256 cellar: :any_skip_relocation, sonoma:        "27caf31ac3919ea126a7c469b3eaf8739856ed41fad5f9572f77007a4a07bc08"
    sha256 cellar: :any_skip_relocation, ventura:       "27caf31ac3919ea126a7c469b3eaf8739856ed41fad5f9572f77007a4a07bc08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e82f5ee68aae2ae92ffa726006da57cbb050174abf510d2c75ae04a13ad92c2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bombardier --version 2>&1")

    url = "https:example.com"
    output = shell_output("#{bin}bombardier -c 1 -n 1 #{url}")
    assert_match "Bombarding #{url} with 1 request(s) using 1 connection(s)", output
  end
end