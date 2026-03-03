class Quint < Formula
  desc "Core tool for the Quint specification language"
  homepage "https://github.com/informalsystems/quint"
  url "https://registry.npmjs.org/@informalsystems/quint/-/quint-0.31.0.tgz"
  sha256 "f1ba3ac13f5fd5c1439cf6b6518a56b871ec6ac4c634b2044de23e7a3cc572a8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e23549d53ff802e620b55539f16ce88eda7d81298c5ec39104c1ebcd242a692d"
  end

  # Remove when Node 25 is fixed upstream: https://github.com/nodejs/node/issues/61971
  # Formula-specific tracking: https://github.com/informalsystems/quint/issues/1926
  depends_on "node@24"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/quint --version")

    (testpath/"bank.qnt").write <<~QNT
      module bank {
        var balances: str -> int
        pure val ADDRESSES = Set("alice", "bob", "charlie")

        action deposit(account, amount) = {
          balances' = balances.setBy(account, curr => curr + amount)
        }

        action withdraw(account, amount) = all {
          balances.get(account) >= amount,
          balances' = balances.setBy(account, curr => curr - amount),
        }

        action init = { balances' = ADDRESSES.mapBy(_ => 0) }

        action step = {
          nondet account = ADDRESSES.oneOf()
          nondet amount = 1.to(100).oneOf()
          any { deposit(account, amount), withdraw(account, amount) }
        }

        val no_negatives = ADDRESSES.forall(addr => balances.get(addr) >= 0)
      }
    QNT

    out = shell_output("#{bin}/quint compile bank.qnt")
    assert_match "\"stage\":\"compiling\"", out
    assert_match "\"main\":\"bank\"", out
  end
end