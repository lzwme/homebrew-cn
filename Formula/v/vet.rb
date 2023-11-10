class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://ghproxy.com/https://github.com/safedep/vet/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "1a5062586b799e3dd2fcf6cecdccce82753a225fe8e2f3166a5ce5d3d3a1b995"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ec888f21e15f11729112acc88c9b47a1c79e7eb0389884bad51ee0b976d1204"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "170183de834f4c79b1c72478a6b8354c9cea03defbebb5be712d8dfe95fb1136"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e34c8aa2fe07475647ccff5ce8b8c871d2985182ccc277fc053358687d78b327"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e72d0d49eda2d013cdcda00ba579a8ec133fb29742289253099fff4130a3583"
    sha256 cellar: :any_skip_relocation, ventura:        "e30914a0f7f015569e8a674b7ed28bf8ec464e3c1b2f9220f346334853bfa5c6"
    sha256 cellar: :any_skip_relocation, monterey:       "c26e81c0bdcc0015710c0500c83f4c9d2d6625184764a7c4869ebc1f9f0c0245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af334a6ea4772762c50a8869c2e72d2d8807232f1064df8ca58e5df1f11ec17a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end