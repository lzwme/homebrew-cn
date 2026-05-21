class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://ghfast.top/https://github.com/apollographql/rover/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "102556dc988356967a91f278139aa5bf793d26c104e61468918334275a56a491"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74c0540c67e54c94cce28cff4459445495aac27e722c78dfd5367463634b0d45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75d03475e07d6ca5b1415b5ca631a119df72089372dbdbebcb1465e3ad4a5ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e8ecb097436a8c7b91a4a31fd5ea4455dd02a710ce99f7e4bc0f2d2aecac832"
    sha256 cellar: :any_skip_relocation, sonoma:        "5975cbd4a86a0de9f1f7cc76e72875bf6de8585e74ff1f8b2e191911bd6ef215"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a28d77f0d2d80202432e72a65c5eea3f799e95f048fd6ec4a8621bb6018821f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a170dbcae13f74149c49d70205c6eba2b81b07fab4ea6a247a165d0c6b3b382f"
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