class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.4.10.tar.gz"
  sha256 "1ece5d27eff473755b492efbde2abbdfa50ba37f787ab519eab1877c381b90fe"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc02dca171fc15b2eae339c29f3c41129f9f2f71b4e93c7cb5850f8255e7b4f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ed0efc27160f876bc1fc7be769ff12f86b26e7fa8f6feee751455a00af4bd2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "490c88327df98bf4259afc066cb01d0c584c05e5ff5d98c64826a3f3e9612b0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "97fe292cde190ee3fbe0bfb01bb70e19e24984f2498511ffe3f5e2bc2524b9e0"
    sha256 cellar: :any_skip_relocation, ventura:        "dd8c1cc6c86df2f326f21fadd505034ff0454e026b9d5b965ff14b32f6c6ea81"
    sha256 cellar: :any_skip_relocation, monterey:       "b3f3c942920f22990499c2bd80ee65a74342388a7e3769ebcd8126ae06259526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c23ac52d4ad772fdd81228ceba51f78d257a7a2ec609e39ea0f60c7a6db41bb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end