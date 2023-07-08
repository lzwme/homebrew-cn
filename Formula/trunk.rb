class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://ghproxy.com/https://github.com/thedodd/trunk/archive/v0.17.2.tar.gz"
  sha256 "020805e2d84ae423594c724e118fd2db52a34f4795f61f843a27c2878ce23ee3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17de3af3ddfb11579cd062fd7f02a10a0f956e8df79849463ff02aa8a8fd217f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c9e711c4ea63b57d98780d316d413d80083f471e5dde9b722aab5604cfbac73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51d2946976bab679273845752bec31433c18df5f0870160fba46e96096ac5aed"
    sha256 cellar: :any_skip_relocation, ventura:        "12c7681fe56cc744e1945ea85df6ab9d43a812cf0242a705f7a74ec56ca3a7bc"
    sha256 cellar: :any_skip_relocation, monterey:       "8d5257abb74db2e9d6dac42cff5d14c5a4f8d46c9973c24df2a5fc2b9c056595"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f8f36039326980b7de17ffa8c47e53d0b42b6de4001044e56dc962798a53748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec0d6f6c32a2015e236b3d93106248d4e67378c0662e50b33ff2466aff5bc4c0"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end