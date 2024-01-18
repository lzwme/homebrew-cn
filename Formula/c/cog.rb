class Cog < Formula
  desc "Containers for machine learning"
  homepage "https:github.comreplicatecog"
  url "https:github.comreplicatecogarchiverefstagsv0.9.2.tar.gz"
  sha256 "853befc8934b44e2b1ae6088aad16cc4ad9d5c22f19ed754fc576c0f64aed21f"
  license "Apache-2.0"
  head "https:github.comreplicatecog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29757cbc3387a2076a86d8a568de28f9e77ffda690bbc8353ba06b762cda24bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5129465f87719dd3b137607eefc700076e89cbef939dddbb6bc5783bc3cdf5df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8d44fd80cdbddb13ab65d88a3647870f98f46125d07d3cfdf4db739f014f85b"
    sha256 cellar: :any_skip_relocation, sonoma:         "faa55311394cbcd0aefa1ec6540541b44c4c6e3d878f2a672bd8ac046791e052"
    sha256 cellar: :any_skip_relocation, ventura:        "b447dd1c17000d09ba2c377033be95fffe1a887e29647aa0994b118d144e8da0"
    sha256 cellar: :any_skip_relocation, monterey:       "b5471fc08baeee8a76d1edbbac78cf497ac5e8164abfb123e519a0130ff056a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6025bde800556c619824781c8b3704ab4fb08ee4fe9f894b410d4bcb997139d"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}cog build 2>&1", 1)
  end
end