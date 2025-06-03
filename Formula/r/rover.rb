class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https:www.apollographql.comdocsrover"
  url "https:github.comapollographqlroverarchiverefstagsv0.32.1.tar.gz"
  sha256 "9519cc02fa0c9bd5dcd0552db01ec8ee0698a409e4c8af721fb8d2e8654b998a"
  license "MIT"
  head "https:github.comapollographqlrover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d6625cecced5969fea12f4e8201d144ed20dda8647bbfe57580e363cc34f8f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10b53d7038e3d7f3f2b52898896e884a8efb42f10450ad993a34b4caa635c7b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "236af740d47ce508a9d1a97f9412b096eef53ea878b3953d12212d05693b2585"
    sha256 cellar: :any_skip_relocation, sonoma:        "d771e62d4ecd651f9c871bb2d17dba18bc6708bbd5ea759cfe8beaee329ec86c"
    sha256 cellar: :any_skip_relocation, ventura:       "68ebe9e00632136dca8b45ca62ea16d1eba3af4d6b2561091eb73629aff9681e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "814b21c02d1022e5f0885644b6229afd02bea744415b1215bb7a484cbfbaef0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f28438e843baaac3a3ef4a06b24be27e477d7c3dd1b774d8c34c46b0ed0a17a"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}rover graph introspect https:graphqlzero.almansi.meapi")
    assert_match "directive @specifiedBy", output

    assert_match version.to_s, shell_output("#{bin}rover --version")
  end
end