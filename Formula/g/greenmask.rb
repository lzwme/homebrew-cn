class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.1.11.tar.gz"
  sha256 "f53a976e3f93a7b35322fa164e3a64f7bda46f2bbec52073dae62e0f0953880d"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "177c6050dd39dc450451fb50404c9282ac00b54a0e3aa67767d97095a7503f42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691730e4b54922e6cc74a4f58c80f7cacf281b2d674c4809461c689ffa417b46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71f79c41773d53a1f353fe7a86fde7e8fa7b7decd276bc995dd2908231bf243c"
    sha256 cellar: :any_skip_relocation, sonoma:         "612ce43cc387bda73eca8c8330ed01d0e505012e8c787d9dfcb27a033100d21d"
    sha256 cellar: :any_skip_relocation, ventura:        "f8097d38b2760beec4ed8f5f73c169c11bd8c56bec4cda0fb8cbd0ed46b0d786"
    sha256 cellar: :any_skip_relocation, monterey:       "75dbd3b5d34fb51b48baf03f832876c68195a78f7a2364197dbde23b089f34dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e24e247e52d8db0db83a8421d4337c0914da0bb7d9f321c2e9eee98006269e9"
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