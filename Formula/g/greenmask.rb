class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.1.13.tar.gz"
  sha256 "4df1ecffb0efaca78a8183c3c986ff0c64592f804f945360cf657d6dc182a2d7"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29de579b8b2a8b280d8fefd3d8112562c8b865ba5bcbfae3b468f5a22b10e8fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97640616d05f19eed324cf86d0c3e13afb563e525c83152d705c1c587cf15fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8efa35dea02b4a40338d30dedf54b5d0e0ebf74137f46eb0f8da62eaab3d499d"
    sha256 cellar: :any_skip_relocation, sonoma:         "05313bd105ab669cdc18acf9fe275fc88e0998c298971592ba4d22fb432911d1"
    sha256 cellar: :any_skip_relocation, ventura:        "285286c599bdb37d58f4521c8218ddc9afaaf0ea48a3e914ae623708e594c6bc"
    sha256 cellar: :any_skip_relocation, monterey:       "8c4ea810f03a60bd3dd578f7c622a6ac0a95578d63845ee1e06d36f444a29796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ad9a3ce85970d69e662365cc3250abe4c6854e8c80e9d391626120fdf668a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdgreenmask"

    generate_completions_from_executable(bin"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}greenmask -v")

    (testpath"config.yml").write <<~EOS
      common:
      pg_bin_path: "usrlibpostgresql16bin"
      tmp_dir: "tmp"

      storage:
        s3:
          endpoint: "http:playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    EOS
    output = shell_output(bin"greenmask --config config.yml list-transformers")
    assert_match "Generate random uuid", output
  end
end