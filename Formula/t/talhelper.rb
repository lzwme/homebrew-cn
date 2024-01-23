class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv1.17.1.tar.gz"
  sha256 "3c04eced572e6d4be242e0e0417e3d4f5a1286bf83a4eec6541693500debfc54"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30eaf7bdcb685ec5cfa742ae906ad6bb03c4b304fe32fc81ab397f5f6cc05bfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d894071b67441a07f049656115a914d418d0eb2b3af653d512f23322dd69ccd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e77cdc4ac89ff2d490589d9805879d9a1ba49467d4baea856910e5e898bdc940"
    sha256 cellar: :any_skip_relocation, sonoma:         "28f7ef5c34a66f4b9359d9839fa70440f432d82b9adb13087b348046b1c400ed"
    sha256 cellar: :any_skip_relocation, ventura:        "189fed82bc95e4621d15a7896a5711ab8b1035043db486ca9c25d05e638b8e52"
    sha256 cellar: :any_skip_relocation, monterey:       "810bee214203eee359f302a59b4af66fdcf491893c1fd87dd93db2a5455751f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d020676f3e80f0033fe6744d72674c609dc0bf45c5b3e7d18ce8f979cf993dbe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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