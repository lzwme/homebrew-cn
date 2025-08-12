class Darklua < Formula
  desc "Command-line tool that transforms Lua code"
  homepage "https://darklua.com/"
  url "https://ghfast.top/https://github.com/seaofvoices/darklua/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "71de9e35c80b2a3476fda1597530d207fe9dd9b0910e3ce96171eddea1920d69"
  license "MIT"
  head "https://github.com/seaofvoices/darklua.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad925dacaf8551dfe4ca0ea1addd0314d571b0e67ae4ec5a1597649d2df5e10e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74fb9e60cf6b7652b666ce2b901581ed1bf1a0eb721058ae29a2d6f196440950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0571d47a04a9e245679f1f4309f53163b5e1dee9157123c5a8efcea10ccbb167"
    sha256 cellar: :any_skip_relocation, sonoma:        "d756debd6fe3e5466942c3f1e68b434b0b8da4385a6a6db8f84c2b3c6df3ccab"
    sha256 cellar: :any_skip_relocation, ventura:       "cf26ba133aeee383dbbf2fbab749a44dd9c5cd1e075ccb5f5084d5cd82920141"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65534493caa38fdb2f83ff44e4e7997921517c4abb03ea706f30d34f5d048ea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "626880eb981770cf67859ff30b07c2581446073cac5fbcc6a6190b2c4e52a222"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/".darklua.json").write <<~JSON
      {
        rules: [
          'remove_spaces',
          'remove_comments',
          'compute_expression',
          'remove_unused_if_branch',
          'remove_unused_while',
          'filter_after_early_return',
          'remove_empty_do',
          'remove_unused_variable',
          'remove_method_definition',
          'convert_index_to_field',
          'remove_nil_declaration',
          'rename_variables',
          'remove_function_call_parens',
        ],
      }
    JSON

    (testpath/"test.lua").write <<~LUA
      -- paste code here to preview the darklua transform
      local foo = 1
      local redundant_variable = ""
      print(foo)

      for _, v in ipairs{1, 2, 3} do
        for _, b in ipairs{5, 6, 7} do
          print(v + b)
        end
      end
    LUA

    (testpath/"expected.lua").write <<~LUA

      local a=1

      print(a)

      for b,c in ipairs{1,2,3}do
      for d,e in ipairs{5,6,7}do
      print(c+e)
      end
      end
    LUA

    system bin/"darklua", "process", testpath/"test.lua", testpath/"output.lua"
    assert_path_exists testpath/"output.lua"
    # remove `\n` from `expected.lua` file
    assert_equal (testpath/"output.lua").read, (testpath/"expected.lua").read.chomp
  end
end