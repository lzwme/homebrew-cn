class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghfast.top/https://github.com/apollographql/rover/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "9b2811b7ba731061d88333cf1ef1b0c119da2223108e12d834b948f8e9382da8"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ebf87b7d81066ac29945a243038ee4723af87e8ebeabd647a735524e1fbcac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2162afac11b953a36f57e3541da1f6a1860f293724ca0a3db79f585cbc1052a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a04602900477c38942c9500450b5d55dcc1c43ac597eec344a6610c5e758167"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f1f63f9a860fc47431c0af4afeb6f3226bc1bad79eeda99d69caad6bee04c8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5db48d0547755d205b1f6450be86d17d6b58fdde52d8137502a6ff1dcf9e0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a9e279b13f72c6447dd1b9ec6ae601cd7c76429ddcd8cc83ddea1c854ded7a3"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rover", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end