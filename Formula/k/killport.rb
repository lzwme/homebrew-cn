class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https:github.comjkfrankillport"
  url "https:github.comjkfrankillportarchiverefstagsv1.0.0.tar.gz"
  sha256 "c98625b94f658979d82f5d1fa563d8380a35e2155f13e435639bd32d4d5656f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6b9dac4aab0565fe1ae9c04283ca15022a600f4389d2dc0584c395a2692ee57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee9c397ac396738d5db0e9cfb4116369c3d962420c84b8ade1ab793d6f9e0e1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2dad5c91f02261b2b982aab470c541d424ee4636e641824449d15c66cb00a52"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5b8a1284dd4e9abd656a809f5193d3d63fcfd4823d68b85d9e2ce8eb9dc9708"
    sha256 cellar: :any_skip_relocation, ventura:        "8aa5c7876fcddfee8e841744800cec957e6c6b6ebc5ab2f94c4d135ea251d7eb"
    sha256 cellar: :any_skip_relocation, monterey:       "5a98d8cdf4580c742e20a781056386508c7c3a6774c40496eacd2dac4d4ee660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee49a3ea41f4c2ca0880ef8c80f38981caed8660de64a40a41176a8715cfd094"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    output = shell_output("#{bin}killport --signal sigkill #{port}")
    assert_match "No service found using port #{port}", output
  end
end