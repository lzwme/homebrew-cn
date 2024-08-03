class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https:github.comsigodenargc"
  url "https:github.comsigodenargcarchiverefstagsv1.20.0.tar.gz"
  sha256 "7510a0f1540213bf0ac81a03a0df73a0dca7c6c54c873853962e2f754f11e14e"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85a4939d8ace2d8a9f76906e7bd719937d75f4fdeff5448f5e81f5896753ba54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e599594929c4687a4f528cc492393a95861e8bd941cc8bbaadc8659bd83aaa42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342484092268fcb99bd76551ee5b27aa918028ba0f9c69ff8bee424e62a4e5d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c676d81feef68a475814dacad46b28da4cf74b71fcf23f497a9023744ba0a56"
    sha256 cellar: :any_skip_relocation, ventura:        "474f1499fb2b0f08b3d4dd543fd5d94181b5da40f8640c5b924a2992a8ccb639"
    sha256 cellar: :any_skip_relocation, monterey:       "169cfb09196c9c991938523347bce757e93b5b29b21bf4f04df00b5e055ed026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "970d646e7c810601acda2ff042c26cac311121a93a50e77ae5f215548a4cdc0e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"argc", "--argc-completions")
  end

  test do
    system bin"argc", "--argc-create", "build"
    assert_predicate testpath"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}argc build")
  end
end