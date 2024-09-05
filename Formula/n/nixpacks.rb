class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.28.0.tar.gz"
  sha256 "c412f46f9243052e98cc847fefd4b53a006252a519c117868a5f10eed257661b"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "812cfc20d068ef11fb1dd41cab5d79cb71a8238cee1312acbcc7f9065391ef79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7455065bd4f74f7c56eb640bc01b486ac66480bb5e4a6e46699df0dacfd74f8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3685f83aee4e0b640e6d54353e6cdd4627bae0661719464ebdc5a0bd10e802e"
    sha256 cellar: :any_skip_relocation, sonoma:         "41464f64e99a57af2809c977401a8e920f1ac604b73dd5fd7482831a4d39884a"
    sha256 cellar: :any_skip_relocation, ventura:        "2772da55fdfc893ed761518029c6c982fe4f3e36e6c143073e355085ef87f1f0"
    sha256 cellar: :any_skip_relocation, monterey:       "b3b5fe5a2bbdfac8aa70a81d1872adeb35e5605d2bf96ed395a755e955662470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068d2c2b5c997741f91ba1556cfd3683ebae0e511f193d36e1fa748caaa01c41"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}nixpacks -V").chomp
  end
end