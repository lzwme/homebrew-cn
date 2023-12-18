class Nickel < Formula
  desc "Better configuration for less"
  homepage "https:github.comtweagnickel"
  url "https:github.comtweagnickelarchiverefstags1.3.0.tar.gz"
  sha256 "cd6919eb945992721bd164291ebee11dbb62f06004061c0cfc5fa73e98197224"
  license "MIT"
  head "https:github.comtweagnickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f1c678b1835a86dc1d2d741fa7e44eecdb913e3ac7efb0b3425c7fd3ae3d788"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fcd36f5919d5a0089d0add8decfc8871653ea967027dbf80a2690a8d780cd5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a68ecd226cbbae9fa3a07087a94130b77fcf41fd462bb69e3cb7974e675faba"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a25033dc8797538cccf23dfad96f539b339cc563c85b5b19f1384fe29cee726"
    sha256 cellar: :any_skip_relocation, ventura:        "76abdc406612ac2b6240dbde4c0f7e5bdfec74566aac9dba167f9014094c5070"
    sha256 cellar: :any_skip_relocation, monterey:       "2d05f6d869fc3f0b32176d4ab5866dd79e03cca309a6df6b196b775679230688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da068d306c394bab58c3488bfeb1d25129d53bcf23dd7beba6e919c66aa5fe1a"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin"nickel", "gen-completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nickel --version")

    (testpath"program.ncl").write <<~EOS
      let s = "world" in "Hello, " ++ s
    EOS

    output = shell_output("#{bin}nickel eval program.ncl")
    assert_match "Hello, world", output
  end
end