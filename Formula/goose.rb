class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://ghproxy.com/https://github.com/pressly/goose/archive/v3.13.0.tar.gz"
  sha256 "5c5d7ce17a5436a1878ad864d2d961391f388494b012756bfc2104ac02070ab7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3de7e5771e5b79a5796972d2189d023aa61aafca8f4e341a8a7fdf183ad6f6ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38106c5b82d555263e03711333d7fb8c1e5a844ccceab8e6719831362cd1f747"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff4a5561536f74813bf968e14f582ca40bd5fc9e7015e467c350313783e75524"
    sha256 cellar: :any_skip_relocation, ventura:        "24e105527f4c468a81d1458001563024744e75f2464bb30f342d632546dac85f"
    sha256 cellar: :any_skip_relocation, monterey:       "07965f1e8e1a716ff1ec5c5f642b6ab80c1d860415253f06655376ae5e7b2933"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d8299eba2592f3dbc69fc75f09cb07d406ef69affef0edce7db493cf8022732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8b73eb6f60a88d19659e6b706c3da0b6a396d4e82152a34ead63eb53611ed7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end