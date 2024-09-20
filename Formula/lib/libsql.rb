class Libsql < Formula
  desc "Fork of SQLite that is both Open Source, and Open Contributions"
  homepage "https:turso.techlibsql"
  url "https:github.comtursodatabaselibsqlreleasesdownloadlibsql-server-v0.24.25source.tar.gz"
  sha256 "93ce5ca3faf5b9809fa32b32b318c2d0903b30608e347786232f85a81c08fe66"
  license "MIT"
  head "https:github.comtursodatabaselibsql.git", branch: "main"

  livecheck do
    url :stable
    regex(^libsql-server-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ca93ad5def9b4745a331f82ccd3344f75bc921c123797b1e8aba787bf489860"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57dab7be33da3c82cd77629506733a985818df4dcab1157fbadffa936ced6e4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8026e5c85098ba4c7b5769c71adabb2983503684e4f1f0710c33d6ac9882db4"
    sha256 cellar: :any_skip_relocation, sonoma:        "86c43c082c3e227e486a3fac597788a7d5b68e0eac59b55940be23ae273c6834"
    sha256 cellar: :any_skip_relocation, ventura:       "829b7f5c5de6b4f9943b55a34454bff0196fc8ad201ec5ba0b5499f03a936d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee99673a18ffea70885451484a2a91ebc7c20088774200cc0d2a716798415e48"
  end

  depends_on "rust" => :build

  def install
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable"
    system "cargo", "install", *std_cargo_args(path: "libsql-server")
  end

  test do
    pid = spawn(bin"sqld")
    sleep 2
    assert_predicate testpath"data.sqld", :exist?

    assert_match version.to_s, shell_output("#{bin}sqld --version")
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end