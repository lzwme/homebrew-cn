class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https:gopeed.com"
  url "https:github.comGopeedLabgopeedarchiverefstagsv1.6.4.tar.gz"
  sha256 "73e9fdc4100d1a02d8b0ab442fddaf33e287b58dbdf916c033a312feddc1461f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea70bdb86f8c81f89cf034115f9ecd39d8862eae0cd9524eddcfaccb74915981"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec735127fa80d2d7a9e157ff9221751e49d9c5f682b90c15c3fab60f547e36c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42c5e12669da3487d7b87fbeb527d87eec81d0222311ec40886917452fa8051b"
    sha256 cellar: :any_skip_relocation, sonoma:        "46c572fea117f23df571cc32810f7d599a79f49ea4317d971b5a06d72a136933"
    sha256 cellar: :any_skip_relocation, ventura:       "bdd7e0e6733ce902d3c27416187f717d102791484e4a0c26ecdfe36148969d68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0f579b6c15577d4c631e2037f9da903eaadee612237eff79a2690257211ec5"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgopeed"
  end

  test do
    output = shell_output("#{bin}gopeed https:example.com")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath"example.com").read
  end
end