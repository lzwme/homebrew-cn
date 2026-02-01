class GoAir < Formula
  desc "Live reload for Go apps"
  homepage "https://github.com/air-verse/air"
  url "https://ghfast.top/https://github.com/air-verse/air/archive/refs/tags/v1.64.4.tar.gz"
  sha256 "69c0dbc71d434203c99ae41155ffa5b0a1e46699fcf4e2d14727d429ce290aa2"
  license "GPL-3.0-or-later"
  head "https://github.com/air-verse/air.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b167dfec3d7977dec5c7ef911912aa3f13615c93e9fd0d0338d277bf6bd18466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b167dfec3d7977dec5c7ef911912aa3f13615c93e9fd0d0338d277bf6bd18466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b167dfec3d7977dec5c7ef911912aa3f13615c93e9fd0d0338d277bf6bd18466"
    sha256 cellar: :any_skip_relocation, sonoma:        "eebdb64815e39accaba3827ccfa64362327e9def29125ce77210da2769e1ae99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4059eb4d8f78e4869883a06acc135d776702410ffcbb3847ec8d4acd0cb64ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dcaeb142786456d8854d67b3db9f74444807e15fbc699f8c5e55b19a39549fb"
  end

  depends_on "go"

  conflicts_with "air", because: "both install binaries with the same name"

  def install
    ldflags = [
      "-s", "-w",
      "-X", "'main.BuildTimestamp=#{time.iso8601}'",
      "-X", "'main.airVersion=v#{version}'",
      "-X", "'main.goVersion=#{Formula["go"].version}'"
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: bin/"air")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/air -v")
    (testpath/"air-test").mkpath
    cd testpath/"air-test" do
      system "go", "mod", "init", "air-test"
      system bin/"air", "init"
    end
    assert_path_exists testpath/"air-test/.air.toml"
  end
end