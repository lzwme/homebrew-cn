class Erigon < Formula
  desc "Implementation of Ethereum (execution client), on the efficiency frontier"
  homepage "https://github.com/ledgerwatch/erigon"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]
  head "https://github.com/ledgerwatch/erigon.git", branch: "devel"

  stable do
    url "https://ghproxy.com/https://github.com/ledgerwatch/erigon/archive/refs/tags/v2.43.1.tar.gz"
    sha256 "0d6f77f76f0b3a5d3290fd58d786fbbe472d0d891265c929517ef4879d8d9a66"

    # patch to use go-m1cpu v0.1.5
    # upstream commit ref, https://github.com/ledgerwatch/erigon/commit/fe30cf8c6f8ca8999cf55c94383ee9c34b3c0640
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bb9f08d0eac3ef7f5bac0e532ab3a0534e74af779f20c5ff6937c79e183c10b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ec4db5e70959cd1f3080b4b814637940a11c559b2dddcf1686d190ecff0d55b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21fafa227a6ba4438160f244954b6101ea7cadf465c0668bb52067437cd286e8"
    sha256 cellar: :any_skip_relocation, ventura:        "2194203cc27c2b9b5674c324e97587378cd3482c66bc75c6833511377e12ef1a"
    sha256 cellar: :any_skip_relocation, monterey:       "7572a087049a42136405076145de7167bdd78f404c79e12378ad6411f1b11d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "dac5c9aaf0287584b8e5e690b66a11e8eef4e420c83b89494071268e90c8c81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f5f6686c4f36887676bc6885c59da1e5794b0c5bf083d0c8ef498cd55fbe614"
  end

  depends_on "gcc" => :build
  depends_on "go" => :build
  depends_on "make" => :build

  conflicts_with "ethereum", because: "both install `evm` binaries"

  def install
    unless build.head?
      ENV["GIT_COMMIT"] = "unknown"
      ENV["GIT_BRANCH"] = "release"
      ENV["GIT_TAG"] = "v#{version}"
    end

    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    args = %W[
      --datadir testchain
      --log.dir.verbosity debug
      --log.dir.path #{testpath}
    ]
    system "#{bin}/erigon", *args, "init", "genesis.json"
    assert_predicate testpath/"erigon.log", :exist?
  end
end

__END__
diff --git a/go.mod b/go.mod
index 38a4f09..618e77c 100644
--- a/go.mod
+++ b/go.mod
@@ -233,7 +233,7 @@ require (
 	github.com/rogpeppe/go-internal v1.9.0 // indirect
 	github.com/rs/dnscache v0.0.0-20211102005908-e0241e321417 // indirect
 	github.com/russross/blackfriday/v2 v2.1.0 // indirect
-	github.com/shoenig/go-m1cpu v0.1.4 // indirect
+	github.com/shoenig/go-m1cpu v0.1.5 // indirect
 	github.com/spaolacci/murmur3 v1.1.0 // indirect
 	github.com/supranational/blst v0.3.10 // indirect
 	github.com/tklauser/go-sysconf v0.3.11 // indirect
diff --git a/go.sum b/go.sum
index 5b2a3ad..2f119ca 100644
--- a/go.sum
+++ b/go.sum
@@ -717,8 +717,9 @@ github.com/sergi/go-diff v1.1.0 h1:we8PVUC3FE2uYfodKH/nBHMSetSfHDR6scGdBi+erh0=
 github.com/sergi/go-diff v1.1.0/go.mod h1:STckp+ISIX8hZLjrqAeVduY0gWCT9IjLuqbuNXdaHfM=
 github.com/shirou/gopsutil/v3 v3.23.3 h1:Syt5vVZXUDXPEXpIBt5ziWsJ4LdSAAxF4l/xZeQgSEE=
 github.com/shirou/gopsutil/v3 v3.23.3/go.mod h1:lSBNN6t3+D6W5e5nXTxc8KIMMVxAcS+6IJlffjRRlMU=
-github.com/shoenig/go-m1cpu v0.1.4 h1:SZPIgRM2sEF9NJy50mRHu9PKGwxyyTTJIWvCtgVbozs=
 github.com/shoenig/go-m1cpu v0.1.4/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
+github.com/shoenig/go-m1cpu v0.1.5 h1:LF57Z/Fpb/WdGLjt2HZilNnmZOxg/q2bSKTQhgbrLrQ=
+github.com/shoenig/go-m1cpu v0.1.5/go.mod h1:Wwvst4LR89UxjeFtLRMrpgRiyY4xPsejnVZym39dbAQ=
 github.com/shoenig/test v0.6.3 h1:GVXWJFk9PiOjN0KoJ7VrJGH6uLPnqxR7/fe3HUPfE0c=
 github.com/shoenig/test v0.6.3/go.mod h1:byHiCGXqrVaflBLAMq/srcZIHynQPQgeyvkvXnjqq0k=
 github.com/shurcooL/component v0.0.0-20170202220835-f88ec8f54cc4/go.mod h1:XhFIlyj5a1fBNx5aJTbKoIq0mNaPvOagO+HjB3EtxrY=