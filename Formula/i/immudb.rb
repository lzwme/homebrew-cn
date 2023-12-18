class Immudb < Formula
  desc "Lightweight, high-speed immutable database"
  homepage "https:www.codenotary.io"
  url "https:github.comcodenotaryimmudbarchiverefstagsv1.9DOM.0.tar.gz"
  version "1.9.0"
  sha256 "62d2638cf2e7005045441e7c44457dd6686714b85b54be98c1460c228f4ddc94"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "834e9427584a33dc302feac93faec7f206439500d8c2e123e7adf06659cb0fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d5d4eef5cf3c16a668393215399d58e17f11a2cad00bf1946bd61a773fe6889"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "058de2088ed836a8cfaac661568c649c1f6dbb4070b3cc0de73466fe23e6eb17"
    sha256 cellar: :any_skip_relocation, sonoma:         "1514af18dc0a24acd9e4432b92373e22f00603420a6fec4892d53f9a12e13202"
    sha256 cellar: :any_skip_relocation, ventura:        "395b96224666a93a8559f4e139da56af4bf8833e3e57aa9598a8baf677f31965"
    sha256 cellar: :any_skip_relocation, monterey:       "2df58871fb914df342910ffc5f2c2fa25c889f5b5014ab1e57bf4274100a057e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d979a4d4f3969f537aba36f911653acc53f60095f5b7c34d62f206cfc7376b5e"
  end

  depends_on "go" => :build

  def install
    ENV["WEBCONSOLE"] = "default"
    system "make", "all"

    %w[immudb immuclient immuadmin].each do |binary|
      bin.install binary
      generate_completions_from_executable(binbinary, "completion")
    end
  end

  def post_install
    (var"immudb").mkpath
  end

  service do
    run opt_bin"immudb"
    keep_alive true
    error_log_path var"logimmudb.log"
    log_path var"logimmudb.log"
    working_dir var"immudb"
  end

  test do
    port = free_port

    fork do
      exec bin"immudb", "--port=#{port}"
    end
    sleep 3

    assert_match "immuclient", shell_output("#{bin}immuclient version")
    assert_match "immuadmin", shell_output("#{bin}immuadmin version")
  end
end